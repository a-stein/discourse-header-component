const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

// Exercise the real component methods without pretending to run Ember or its UI.
// Only imports, decorator syntax and the Glimmer template are removed here.
const source = fs.readFileSync(path.join(__dirname, '../javascripts/discourse/components/no-cookie-settings.gjs'), 'utf8');
const component = source.slice(source.indexOf('export default class'), source.indexOf('  <template>'))
  .replace('export default ', '')
  .replace(/@(?:tracked|service) /g, '')
  .replace(/  @action\n/g, '') + '}';

function setup({ apiReady = false, scriptPresent = false, load = async () => {} } = {}) {
  const timers = new Map();
  let nextId = 0;
  const window = { googletag: apiReady ? { apiReady: true } : undefined };
  const calls = [];
  const schedule = (fn, ms, repeat) => { const id = ++nextId; timers.set(id, { fn, ms, repeat }); return id; };
  const context = vm.createContext({
    Component: class { willDestroy() {} }, window,
    document: { querySelector: () => scriptPresent ? {} : null },
    loadScript: async (...args) => { calls.push(args); await load(window); },
    setTimeout: (fn, ms) => schedule(fn, ms, false),
    setInterval: (fn, ms) => schedule(fn, ms, true),
    clearTimeout: id => timers.delete(id), clearInterval: id => timers.delete(id),
  });
  const control = vm.runInContext(`${component}; new NoCookieSettings()`, context);
  const tick = () => { for (const timer of [...timers.values()].filter(t => t.repeat)) timer.fn(); };
  const timeout = () => {
    for (const [id, timer] of [...timers].filter(([, t]) => !t.repeat)) { timers.delete(id); timer.fn(); }
  };
  function ready() {
    const queue = [];
    let opens = 0;
    window.googlefc = { callbackQueue: queue, showRevocationMessage: () => opens++ };
    return { queue, get opens() { return opens; } };
  }
  return { window, control, calls, timers, tick, timeout, ready };
}

test('first click survives asynchronous GoogleFC bootstrap and opens once', async () => {
  const s = setup({ load: async window => { window.googlefc = { callbackQueue: [] }; } });
  await s.control.open();
  await s.control.open();
  assert.equal(s.calls.length, 1);
  assert.match(s.calls[0][0], /gpt\.js\?network-code=23326979771$/);
  assert.equal(s.window.googletag.cmd.length, 0);
  const cmp = s.ready(); // Bootstrap can replace a pre-initialization object.
  s.tick(); s.tick();
  assert.equal(cmp.queue.length, 1);
  cmp.queue[0].CONSENT_API_READY(); cmp.queue[0].CONSENT_API_READY();
  assert.equal(cmp.opens, 1);
  assert.equal(s.control.loading, false);
  assert.equal(s.control.failed, false);
  assert.equal(s.timers.size, 0);
});

test('already ready CMP opens through its supported queue without loading GPT', async () => {
  const s = setup(); const cmp = s.ready();
  await s.control.open();
  assert.equal(s.calls.length, 0);
  cmp.queue[0].CONSENT_API_READY();
  assert.equal(cmp.opens, 1);
  assert.equal(s.timers.size, 0);
});

for (const state of [{ apiReady: true }, { scriptPresent: true }]) {
  test(`reuse existing GPT: ${JSON.stringify(state)}`, async () => {
    const s = setup(state);
    await s.control.open();
    assert.equal(s.calls.length, 0);
    const cmp = s.ready(); s.tick(); cmp.queue[0].CONSENT_API_READY();
    assert.equal(cmp.opens, 1);
  });
}

test('timeout cleans timers, ignores late callback, and allows a retry', async () => {
  const s = setup({ apiReady: true }); const cmp = s.ready();
  await s.control.open(); s.timeout();
  assert.equal(s.control.failed, true);
  assert.equal(s.control.loading, false);
  cmp.queue[0].CONSENT_API_READY();
  assert.equal(cmp.opens, 0);
  await s.control.open(); cmp.queue[1].CONSENT_API_READY();
  assert.equal(cmp.opens, 1);
  assert.equal(s.timers.size, 0);
});

test('failed script load clears timers and exposes retry state', async () => {
  const s = setup({ load: async () => { throw new Error('blocked'); } });
  await s.control.open();
  assert.equal(s.control.failed, true);
  assert.equal(s.control.loading, false);
  assert.equal(s.timers.size, 0);
});

test('unmount clears the readiness poll and prevents queued opening', async () => {
  const s = setup({ apiReady: true }); const cmp = s.ready();
  await s.control.open();
  s.control.isDestroying = true; s.control.willDestroy();
  cmp.queue[0].CONSENT_API_READY();
  assert.equal(cmp.opens, 0);
  assert.equal(s.timers.size, 0);
});

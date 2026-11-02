import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { on } from "@ember/modifier";
import { service } from "@ember/service";
import loadScript from "discourse/lib/load-script";

export default class NoCookieSettings extends Component {
  @service siteSettings;
  @tracked loading = false;
  @tracked failed = false;
  timer;
  readinessPoll;

  get enabled() {
    return this.siteSettings.discourse_adplugin_enabled &&
      this.siteSettings.dfp_publisher_id === "23326979771";
  }

  @action
  async open() {
    if (this.loading) { return; }
    this.loading = true;
    this.failed = false;
    const finish = (failed) => {
      clearTimeout(this.timer);
      clearInterval(this.readinessPoll);
      if (!this.isDestroying && !this.isDestroyed) {
        this.loading = false;
        this.failed = failed;
      }
    };
    let expired = false;
    let queued = false;
    let opened = false;
    this.timer = setTimeout(() => { expired = true; finish(true); }, 20000);
    // On pages without ads GPT still has to bootstrap the CMP. Wait for the
    // actual API instead of registering only against a pre-bootstrap stub.
    const queueWhenReady = () => {
      if (expired || queued || this.isDestroying || this.isDestroyed) { return; }
      const fc = window.googlefc;
      if (typeof fc?.showRevocationMessage !== "function" || !fc.callbackQueue) { return; }
      queued = true;
      clearInterval(this.readinessPoll);
      fc.callbackQueue.push({ CONSENT_API_READY: () => {
        if (expired || opened || this.isDestroying || this.isDestroyed) { return; }
        opened = true;
        try { fc.showRevocationMessage(); finish(false); }
        catch { finish(true); }
      } });
    };
    this.readinessPoll = setInterval(queueWhenReady, 100);
    try {
      queueWhenReady();
      if (!queued && !window.googletag?.apiReady &&
          !document.querySelector('script[src^="https://securepubads.g.doubleclick.net/tag/js/gpt.js"]')) {
        window.googletag ||= { cmd: [] };
        // Identify the CMP account even when this page has no ad slot. Leave
        // GPT service/loading configuration entirely to the advertising plugin.
        await loadScript("https://securepubads.g.doubleclick.net/tag/js/gpt.js?network-code=23326979771", { scriptTag: true });
      }
      queueWhenReady();
    } catch { expired = true; finish(true); }
  }

  willDestroy() {
    clearTimeout(this.timer);
    clearInterval(this.readinessPoll);
    super.willDestroy(...arguments);
  }

  <template>
    {{#if this.enabled}}
      <div class="no-cookie-settings">
        <button type="button" class="btn btn-text" disabled={{this.loading}} aria-busy={{this.loading}} {{on "click" this.open}}>
          {{#if this.loading}}Cookie-Einstellungen werden geladen…{{else}}Cookie-Einstellungen{{/if}}
        </button>
        {{#if this.failed}}<span role="status">Nicht verfügbar. Bitte erneut versuchen oder den Inhaltsblocker für diese Seite prüfen.</span>{{/if}}
      </div>
    {{/if}}
  </template>
}

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
      if (!this.isDestroying && !this.isDestroyed) {
        this.loading = false;
        this.failed = failed;
      }
    };
    let expired = false;
    this.timer = setTimeout(() => { expired = true; finish(true); }, 10000);
    window.googlefc ||= {};
    window.googlefc.callbackQueue ||= [];
    window.googlefc.callbackQueue.push({ CONSENT_API_READY: () => {
      if (expired || this.isDestroying || this.isDestroyed) { return; }
      try { window.googlefc.showRevocationMessage(); finish(false); }
      catch { finish(true); }
    } });
    try {
      if (typeof window.googlefc.showRevocationMessage !== "function" &&
          !window.googletag?.apiReady) {
        window.googletag ||= { cmd: [] };
        // Identify the CMP account even when this page has no ad slot. Leave
        // GPT service/loading configuration entirely to the advertising plugin.
        await loadScript("https://securepubads.g.doubleclick.net/tag/js/gpt.js?network-code=23326979771", { scriptTag: true });
      }
    } catch { expired = true; finish(true); }
  }

  willDestroy() {
    clearTimeout(this.timer);
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

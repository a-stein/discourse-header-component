import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class NoGlobalHeader extends Component {
  @service session;

  get colorSchemeClass() {
    return this.session.defaultColorSchemeIsDark
      ? "no-global-header--dark"
      : "no-global-header--light";
  }

  <template>
    <div class="no-global-header {{this.colorSchemeClass}}">
      <a
        class="no-global-header-brand"
        href="https://nintendo-online.de/"
        aria-label="Nintendo-Online.de Startseite"
      >
        <span class="no-global-header-logo" aria-hidden="true"></span>
        <span class="no-global-header-title">Nintendo-Online.de</span>
      </a>

      <nav class="no-global-header-nav" aria-label="Nintendo-Online Navigation">
        <a href="https://nintendo-online.de/news">NEWS</a>
        <span aria-hidden="true">/</span>
        <a href="https://nintendo-online.de/games">SPIELE</a>
        <span aria-hidden="true">/</span>
        <a href="https://nintendo-online.de/reviews">REVIEWS</a>
        <span aria-hidden="true">/</span>
        <a href="https://nintendo-online.de/reports">REPORTS</a>
        <span aria-hidden="true">/</span>
        <a
          class="no-global-header-nav-active"
          href="https://forum.nintendo-online.de/"
          aria-current="page"
        >FORUM</a>
      </nav>
    </div>
  </template>
}

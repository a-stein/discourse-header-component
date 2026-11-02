import { apiInitializer } from "discourse/lib/api";
import NoGlobalHeader from "../components/no-global-header";
import NoCookieSettings from "../components/no-cookie-settings";

const noLinks = [
  ["no-news", "News", "https://nintendo-online.de/news", "scroll"],
  ["no-spiele", "Spiele", "https://nintendo-online.de/games", "puzzle-piece"],
  ["no-reviews", "Reviews", "https://nintendo-online.de/reviews", "star"],
  ["no-reports", "Reports", "https://nintendo-online.de/reports", "file-lines"],
  [
    "no-release-kalender",
    "Release-Kalender",
    "https://nintendo-online.de/games/releases",
    "calendar-days",
  ],
  [
    "no-podcast",
    "Podcast",
    "https://nintendo-online.de/podcasts/pixel-polygone-plauderei",
    "play",
  ],
];

export default apiInitializer((api) => {
  api.renderInOutlet("header-contents__before", NoGlobalHeader);
  api.renderInOutlet("sidebar-footer-actions", NoCookieSettings);

  api.addSidebarSection(
    (BaseCustomSidebarSection, BaseCustomSidebarSectionLink) => {
      const links = noLinks.map(
        ([name, text, href, icon]) =>
          new (class extends BaseCustomSidebarSectionLink {
            get name() {
              return name;
            }

            get href() {
              return href;
            }

            get title() {
              return `${text} auf Nintendo-Online.de`;
            }

            get text() {
              return text;
            }

            get prefixType() {
              return "icon";
            }

            get prefixValue() {
              return icon;
            }
          })()
      );

      return class extends BaseCustomSidebarSection {
        get name() {
          return "nintendo-online";
        }

        get text() {
          return "Nintendo-Online";
        }

        get links() {
          return links;
        }
      };
    }
  );
});

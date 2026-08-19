import { apiInitializer } from "discourse/lib/api";
import NoGlobalHeader from "../components/no-global-header";

const noLinks = [
  ["no-news", "News", "https://nintendo-online.de/news", "newspaper"],
  ["no-spiele", "Spiele", "https://nintendo-online.de/games", "gamepad"],
  ["no-reviews", "Reviews", "https://nintendo-online.de/reviews", "star"],
  ["no-reports", "Reports", "https://nintendo-online.de/reports", "file-lines"],
];

export default apiInitializer((api) => {
  api.renderInOutlet("header-contents__before", NoGlobalHeader);

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

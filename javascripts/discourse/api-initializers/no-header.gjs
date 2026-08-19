import { apiInitializer } from "discourse/lib/api";
import NoGlobalHeader from "../components/no-global-header";

const mobileLinks = [
  ["no-news", "News", "https://nintendo-online.de/news", "newspaper"],
  ["no-spiele", "Spiele", "https://nintendo-online.de/games", "gamepad"],
  ["no-reviews", "Reviews", "https://nintendo-online.de/reviews", "star"],
  ["no-reports", "Reports", "https://nintendo-online.de/reports", "file-lines"],
  ["no-forum", "Forum", "https://forum.nintendo-online.de/", "comments"],
];

export default apiInitializer((api) => {
  // This is a standard outlet, so it can coexist with other header components.
  api.renderInOutlet("header-contents__before", NoGlobalHeader);

  mobileLinks.forEach(([name, text, href, icon]) => {
    api.addCommunitySectionLink({
      name,
      text,
      title: `${text} auf Nintendo-Online.de`,
      href,
      icon,
    });
  });
});

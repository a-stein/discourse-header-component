import { apiInitializer } from "discourse/lib/api";
import NoGlobalHeader from "../components/no-global-header";

const mobileLinks = [
  ["no-news", "NEWS", "https://nintendo-online.de/news", "newspaper"],
  ["no-spiele", "SPIELE", "https://nintendo-online.de/games", "gamepad"],
  ["no-reviews", "REVIEWS", "https://nintendo-online.de/reviews", "star"],
  ["no-reports", "REPORTS", "https://nintendo-online.de/reports", "file-lines"],
  ["no-forum", "FORUM", "https://forum.nintendo-online.de/", "comments"],
];

export default apiInitializer((api) => {
  api.renderInOutlet("home-logo-wrapper", NoGlobalHeader);

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

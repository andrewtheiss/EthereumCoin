function getNavFromUrl(urlString) {
  let navIdx = urlString.lastIndexOf("#") + 1;
  let nav = urlString.substring(navIdx);
  if (navIdx == 0) {
    nav = "";
  }

  switch (nav) {
    case "":
      nav = "home";
      break;
    default:
      break;
  }

  return nav;
}

// Uses  Wolvercoin. pagesLoaded[contentType] to check if the content has
// already been loaded for this page.  If not, it will dynamically call it
// from the /pages/ directory `contentType`.html file.
// Note: 'nav.js is already true'
function checkLoadContentOnceForPage(contentType) {
   var contentLoaded = Wolvercoin.pagesLoaded[contentType];

   if (typeof(contentLoaded) == 'undefined' || !contentLoaded) {
     $("#inner-content-" + contentType).load("/pages/" + contentType +".html");
     Wolvercoin.pagesLoaded[contentType] = true;
     // Show loading
     // Call to load content
   }
}

function showContent(contentType) {
  document.getElementById("menu_" + contentType).classList.add('active');
  document.getElementById("inner-content-" + contentType).classList.remove('hidden');
  checkLoadContentOnceForPage(contentType);
}

function hideContent(contentType) {
  document.getElementById("menu_" + contentType).classList.remove('active');
  document.getElementById("inner-content-" + contentType).classList.add('hidden');
}

window.onhashchange = function(hash) {
   hideContent(getNavFromUrl(hash.oldURL));
   showContent(getNavFromUrl(hash.newURL));
}

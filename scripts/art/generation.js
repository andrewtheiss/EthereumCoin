var height = 640;
var width = 640;

var canvasEl = document.createElement("canvas");
var ctx=canvasEl.getContext("2d");
ctx.canvas.width  =width;
ctx.canvas.height = height;

async function addLayer(context, imgSrc, last = false) {
  var nextImage = new Image();
  nextImage.src = imgSrc;
  nextImage.onload = await function() {
    context.drawImage(nextImage, 0, 0, width, height);
    if (last) {
      var img = canvasEl.toDataURL("image/png");
      document.write('<img src="' + img + '" width="'+ width +'" height="' + height + '"/>');
    }
  };
}

function lol() {
  var img = canvasEl.toDataURL("image/png");
  document.write('<img src="' + img + '" width="'+ width +'" height="' + height + '"/>');

}

async function generateNft() {
  await addLayer(ctx, "bg2.png");
  await addLayer(ctx, "base.png");
  await addLayer(ctx, "face1.png");
  await addLayer(ctx, "hat2.png", true);
  lol();
}

generateNft();

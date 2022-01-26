var height = 640;
var width = 640;

var canvasEl = document.createElement("canvas");
var ctx=canvasEl.getContext("2d");
  ctx.canvas.width  =width;
  ctx.canvas.height = height;
var imageObj1 = new Image();
var imageObj2 = new Image();
imageObj1.src = "bg2.png"
imageObj1.onload = function() {
   ctx.drawImage(imageObj1, 0, 0, width, height);
   imageObj2.src = "base.png";
   imageObj2.onload = function() {
      ctx.drawImage(imageObj2, 0, 0, width, height);
      var img = canvasEl.toDataURL("image/png");
      document.write('<img src="' + img + '" width="'+ width +'" height="' + height + '"/>');
   }
};


async function addLayer(context) {
  var nextImage = new Image();
  nextImage.src = "face1.png";
  nextImage.onload = function() {
     context.drawImage(nextImage, 0, 0, width, height);
     return true;
  };
}

addLayer(ctx);

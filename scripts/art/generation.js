var canvasEl = document.createElement("canvas");
var ctx=canvasEl.getContext("2d");
var imageObj1 = new Image();
var imageObj2 = new Image();
imageObj1.src = "base.png"
imageObj1.onload = function() {
   ctx.drawImage(imageObj1, 0, 0, 640, 640);
   imageObj2.src = "bg2.png";
   imageObj2.onload = function() {
      ctx.drawImage(imageObj2, 0, 0, 640, 640);
      var img = canvasEl.toDataURL("image/png");
      document.write('<img src="' + img + '" width="640" height="640"/>');
   }
};

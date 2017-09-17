<button onclick="startSketch();">Start</button>
<button onclick="stopSketch();">Stop</button>
<div id="gameDiv">
	<canvas id="sketch" data-processing-sources="content/processing-games/genetics.pde"></canvas>
</div>
<script type="application/javascript">
         var processingInstance;
	 document.onload = stopSketch();
         function startSketch() {
             switchSketchState(true);
         }

         function stopSketch() {
             switchSketchState(false);
         }

         function switchSketchState(on) {
             if (!processingInstance) {
                 processingInstance = Processing.getInstanceById('sketch');
             }

             if (on) {
                 processingInstance.loop();  // call Processing loop() function
             } else {
                 processingInstance.noLoop(); // stop animation, call noLoop()
             }
         }
</script>
<?php
$path = getcwd().'/'.config('processing_games_path');
$files = array_diff(scandir($path), array('.', '..'));
foreach ($files as $f){
    if(preg_match('/^\w+[.]pde$/', $f)){
        echo ('<h3>'.ucfirst(str_replace('.pde', '', $f)).'</h3>
            <button onclick="startSketch(\''.$f.'\');">Start</button>
            <button onclick="stopSketch(\''.$f.'\');">Stop</button>
            <div id="gameDiv">
	            <canvas id='.$f.' data-processing-sources="'.config('processing_games_path').'/'.$f.'"></canvas>
            </div>');
    }
}
echo('
<script type="application/javascript">
         var processingInstance;

         function startSketch(instanceName) {
             switchSketchState(true, instanceName);
         }

         function stopSketch(instanceName) {
             switchSketchState(false, instanceName);
         }

         function switchSketchState(on, instanceName) {
             processingInstance = Processing.getInstanceById(instanceName);

             if (on) {
                 processingInstance.loop();  // call Processing loop() function
             } else {
                 processingInstance.noLoop(); // stop animation, call noLoop()
             }
         }
</script>');

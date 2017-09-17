{foreach from=$processingGames item=$pGame}
    <h3>{$pGame}</h3>
    <button onclick="startSketch('{$pGame}');">Start</button>
    <button onclick="stopSketch('{$pGame}');">Stop</button>
    <div id="gameDiv">
        <canvas id={$pGame} data-processing-sources="{$processingGamesPath}/{$pGame}"></canvas>
    </div>
{/foreach}

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
</script>
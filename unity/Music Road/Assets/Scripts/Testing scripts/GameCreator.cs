using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameCreator : MonoBehaviour {
    [SerializeField]
    RoadSpawner roadSpawner;

    [SerializeField]
    TestCar car;

    [SerializeField]
    GameObject testRoad;

    private bool paused = false;
    private Vector3 lastTurnPos;
    private Vector3 carHeightToRoadPos;


    // Start is called before the first frame update
    // zal voor start uitgevoerd worden
    private void Start() {
        TestCar player = Instantiate(car, car.getStartingPosition(new Vector3(0, 0, 0)), transform.rotation) as TestCar;
        FindObjectOfType<TestCameraMovement>().setPlayer(player);
        player.setGameCreator(this);
        carHeightToRoadPos = new Vector3(0, car.transform.position.y+0.1f, 0);
        lastTurnPos = player.transform.position;
    }

    public void createNewRoad(Vector3 currentTurnPos){
        Vector3 distance = currentTurnPos - lastTurnPos;
        Vector3 roadPos = lastTurnPos + distance / 2f - carHeightToRoadPos;
        lastTurnPos = currentTurnPos;

        float roadWidth = 3f;
        Vector3 scale = new Vector3(Mathf.Max(distance.x+6, roadWidth), 1, Mathf.Max(distance.z+6, roadWidth));

        GameObject road = Instantiate(testRoad, roadPos, transform.rotation);
        road.transform.localScale = scale;
    }

    public void updatePos(Vector3 pos) {
        lastTurnPos = pos;
    }

    

    // TODO kan je dan nog altijd klikken om van richting te veranderen?
    public void pauseGame() {
        Time.timeScale = paused ? 1 : 0;

        paused = !paused;
    }

    public void endGame(bool won) {
        print("game won = " + won);
        FindObjectOfType<LevelLoader>().reloadScene();
    }
}
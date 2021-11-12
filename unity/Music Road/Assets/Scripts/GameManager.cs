using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour {
    [SerializeField]
    RoadSpawner roadSpawner;

    [SerializeField]
    Car car;

    [SerializeField]
    GameObject gameCanvas;

    private int[] testRoads = new int[] { // jump length should be length + 12
            50, 10, 20, 30, 20, 40, 30, 17, 30, 50, 10, 20, 30, 40
        };
    private bool[] testRoadJumpIndicators = new bool[] {
            false, false, false, false, false, false, false, true, false, false, false, false, false, false
        };
    private bool paused = false;


    // Start is called before the first frame update
    // zal voor start uitgevoerd worden
    private void Start() {
        // spawn roads
        roadSpawner.instantiateRoads(testRoads, testRoadJumpIndicators);
        // spawn car
        Car player = Instantiate(car, car.getStartingPosition(new Vector3(0, 0, 0)), transform.rotation) as Car;
        FindObjectOfType<CameraMovement>().setPlayer(player);
    }

    // Update is called once per frame
    void Update() {
    }


    public float getTotalDistance() {
        float result = 0f;
        foreach (int length in testRoads) {
            result += length;
        }

        return result;
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
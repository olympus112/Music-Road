using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour {
    [SerializeField]
    Car car;

    [SerializeField]
    GameObject gameCanvas;

    public bool paused = false;



    // Start is called before the first frame update
    // zal voor start uitgevoerd worden
    private void Start() {
        // spawn car
        Car player = Instantiate(car, car.getStartingPosition(new Vector3(0, 0, 0)), transform.rotation) as Car;
        FindObjectOfType<CameraMovement>().setPlayer(player);
    }

    // TODO kan je dan nog altijd klikken om van richting te veranderen?
    public void pauseGame() {
        Time.timeScale = paused ? 1 : 0;

        paused = !paused;
    }

    public void addCoin()
    {
        print("added coin");
    }

    public void endGame(bool won) {
        print("game won = " + won);
        FindObjectOfType<LevelLoader>().reloadScene();
    }
}
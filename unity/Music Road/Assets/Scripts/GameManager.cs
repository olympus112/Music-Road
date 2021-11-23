using System;
using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {
    [SerializeField]
    Car car;

    [SerializeField]
    GameObject gameCanvas;

    private static UnityMessageManager messenger;
    public int coins;
    public bool paused;
    
    private void Start() {
        messenger = GetComponent<UnityMessageManager>();
        Time.timeScale = 1;
        paused = false;
        coins = 0;

        // spawn car
        Car player = Instantiate(car, car.getStartingPosition(new Vector3(0, 0, 0)), transform.rotation) as Car;
        FindObjectOfType<CameraMovement>().setPlayer(player);
    }
    
    // Called from Unity
    public void endGame() {
        print("Unity::endLevel");
        
        LevelProgressionMeter meter = FindObjectOfType<LevelProgressionMeter>();
        double percentage = meter.distanceCovered / meter.totalDistance;
        print("Meter found " + meter);
        
        Dictionary<string, dynamic> parameters = new Dictionary<string, dynamic> {
            {"action", "stop"},
            {"percentage", percentage},
            {"score", percentage * 1000},
            {"coins", coins}
        };
        
        var message = JsonConvert.SerializeObject(parameters);
        messenger.SendMessageToFlutter(message);

        SceneManager.LoadScene(0);
    }

    // Called from Flutter
    public void resumeGame(string message) {
        print("Unity::resumeLevel");
        
        Time.timeScale = 1;
        paused = false;
    }

    // Called from Unity
    public void pauseGame() {
        print("Unity::pauzeLevel");
        
        Time.timeScale = 0;
        paused = true;
        
        LevelProgressionMeter meter = FindObjectOfType<LevelProgressionMeter>();
        print("Meter found " + meter);
        double percentage = meter.distanceCovered / meter.totalDistance;
        Dictionary<string, dynamic> parameters = new Dictionary<string, dynamic> {
            {"action", "pauze"},
            {"percentage", percentage},
            {"score", percentage * 1000}
        };

        var message = JsonConvert.SerializeObject(parameters);
        messenger.SendMessageToFlutter(message);
    }

    public void addCoin() {
        coins++;
    }
}
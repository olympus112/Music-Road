using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {
    [SerializeField]
    Car car;

    [SerializeField]
    GameObject gameCanvas;

    [SerializeField]
    GameObject tapToStartCanvas;

    private static UnityMessageManager messenger;
    private AudioSource audioSource;
    private Car player;
    
    public int coins;
    public bool paused;

    private GameObject currentlyLoadedLevel;
    private LevelLister levelList;

    private void Start() {
        print("GameManager::Start " + SceneManager.GetActiveScene().buildIndex);

        messenger = GetComponent<UnityMessageManager>();
        audioSource = GetComponent<AudioSource>();

        Time.timeScale = 0;
        paused = true;

        levelList = GetComponent<LevelLister>();

        if (!levelList)
            Restart();
    }

    private void Restart(int index = 0) {
        print("GamerManager::Restart " + index);
        
        Time.timeScale = 1;
        paused = false;
        coins = 0;
        audioSource.Stop();

        tapToStartCanvas.SetActive(true);
        
        // Remove current level
        if (currentlyLoadedLevel)
            Destroy(currentlyLoadedLevel);
        
        // Remove player
        if (player)
            Destroy(player.gameObject);
        
        // Reset slider
        FindObjectOfType<LevelProgressionMeter>().resetSlider();
        
        // Init level
        if (levelList) {
            currentlyLoadedLevel = Instantiate(levelList.getLevel(index), transform.position, transform.rotation);
            audioSource.clip = levelList.getSong(index);
        }
        
        // Init player
        player = Instantiate(car, car.getStartingPosition(new Vector3(0, 0, -5)), transform.rotation) as Car;
        FindObjectOfType<CameraMovement>().setPlayer(player);
    }

    public void tapToStart() {
        // twee keer zodat het zeker van het begin speelt
        audioSource.Play(0);

        player.setSpeed();

        tapToStartCanvas.SetActive(false);
    }

    // Called from Unity
    public void endGame(bool won = false) {
        print("Unity::endLevel");

        Time.timeScale = 0;
        paused = true;
        audioSource.Pause();

        LevelProgressionMeter meter = FindObjectOfType<LevelProgressionMeter>();
        double percentage = meter.distanceCovered / meter.totalDistance;

        Dictionary<string, dynamic> parameters = new Dictionary<string, dynamic> {
            {"action", "stop"},
            {"percentage", won ? 1.0 : percentage},
            {"coins", coins},
            {"won", won}
        };

        var message = JsonConvert.SerializeObject(parameters);
        messenger.SendMessageToFlutter(message);
        
        if(!levelList)
            Restart();
    }

    // Called from Unity
    public void pauseGame() {
        print("Unity::pauzeLevel");
        
        audioSource.Pause();
        Time.timeScale = 0;
        paused = true;

        LevelProgressionMeter meter = FindObjectOfType<LevelProgressionMeter>();
        double percentage = meter.distanceCovered / meter.totalDistance;
        Dictionary<string, dynamic> parameters = new Dictionary<string, dynamic> {
            {"action", "pauze"},
            {"percentage", percentage},
            {"coins", coins}
        };

        var message = JsonConvert.SerializeObject(parameters);
        messenger.SendMessageToFlutter(message);
    }

    // Called from Flutter
    public void flutterResumeGame(string message) {
        print("Unity::resumeLevel " + message);

        audioSource.Play(0);

        Time.timeScale = 1;
        paused = false;
    }

    // Called from Flutter
    public void flutterStartGame(string message) {
        print("Unity::startLevel " + message);
        
        var json = JsonConvert.DeserializeObject<Dictionary<string, string>>(message);
        
        int index = Int32.Parse(json["index"]);
        bool sound = Int32.Parse(json["sound"]) != 0;
        bool tapControls = Int32.Parse(json["tap"]) != 0;
        
        Restart(index);
    }

    public void addCoin() {
        coins++;
    }
}
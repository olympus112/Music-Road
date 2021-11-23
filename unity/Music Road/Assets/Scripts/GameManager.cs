using System.Collections.Generic;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {
    [SerializeField]
    Car car;

    [SerializeField]
    GameObject gameCanvas;


    public bool recentleyPaused;

    private AudioSource audioSource;
    private Car player;


    private static UnityMessageManager messenger;
    public int coins;
    public bool paused;
    
    private void Start() {
        print("GameManager::Start " + SceneManager.GetActiveScene().buildIndex);
        
        messenger = GetComponent<UnityMessageManager>();
        audioSource = GetComponent<AudioSource>();

        Time.timeScale = 0;
        paused = true;

        Restart();
    }

    private void Restart() {
        Time.timeScale = 1;
        paused = false;
        coins = 0;

        audioSource.Play(0);// twee keer zodat het zeker van het begin speelt
        audioSource.Play(0);
        
            
        if (player)
            Destroy(player.gameObject);

        player = Instantiate(car, car.getStartingPosition(new Vector3(0, 0, 0)), transform.rotation) as Car;
        FindObjectOfType<CameraMovement>().setPlayer(player);

        player.setSpeed();


    }
    
    // Called from Unity
    public void endGame() {
        print("Unity::endLevel");
        
        Time.timeScale = 0;
        paused = true;
        audioSource.Pause();
        
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
    }

    // Called from Unity
    public void pauseGame() {
        audioSource.Pause();

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
    
    // Called from Flutter
    public void resumeGame(string message) {
        print("Unity::resumeLevel");
        
        audioSource.Play(0);

        Time.timeScale = 1;
        paused = false;
    }

    // Called from Flutter
    public void startGame(string message) {
        print("Unity::startLevel " + message);

        Restart();
    }

    // Called from Flutter
    public void restartGame(string message) {
        print("Unity::restartGame");

        Restart();
    }

    public void addCoin() {
        coins++;
    }
}
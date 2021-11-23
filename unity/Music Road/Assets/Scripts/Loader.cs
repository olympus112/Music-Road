using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Loader : MonoBehaviour
{
    
    private static UnityMessageManager messenger;

    // Start is called before the first frame update
    void Start()
    {
        messenger = GetComponent<UnityMessageManager>();
    }

    // Called from Flutter
    public void startGame(string message) {
        print("Unity::startLevel " + message);

        SceneManager.LoadScene(int.Parse(message));
    }

    public void restartGame(string message) {
        print("Unity::restartGame");

        SceneManager.LoadScene(int.Parse(message));
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelLoader : MonoBehaviour
{

    int currentSceneIndex;


    private void Start()
    {
        currentSceneIndex = SceneManager.GetActiveScene().buildIndex;
    }

    public void loadNextScene()
    {
    }

    public void loadGameOver(bool won)
    {

    }

    public void loadMainMenu()
    {
        Time.timeScale = 1;
    }

    public void LoadLevel()
    {
        Time.timeScale = 1;
        print("loading level");
        SceneManager.LoadScene("TestLevel");
    }

    public void reloadScene()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene(currentSceneIndex);
    }

    public void quitGame()
    {
        Application.Quit();
    }
}

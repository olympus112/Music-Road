using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelLister : MonoBehaviour
{

    [SerializeField]
    List<GameObject> Levels;

    [SerializeField]
    List<AudioClip> Songs;


    public GameObject getLevel(int index) {
        return Levels[index];
    }

    public AudioClip getSong(int index) {
        return Songs[index];
    }
}

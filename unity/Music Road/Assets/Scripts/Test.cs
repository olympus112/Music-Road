using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine;

// A script that plays your chosen song.  The pitch starts at 1.0.
// You can increase and decrease the pitch and hear the change
// that is made.

public class Test : MonoBehaviour
{
    public float pitchValue = 1.0f;
    public AudioClip mySong;

    private AudioSource audioSource;
    private float low = 0.75f;
    private float high = 1.25f;

    void Awake()
    {
        audioSource = GetComponent<AudioSource>();
    }

    private void Start()
    {
        audioSource.Play();
    }

    private void Update()
    {

        if (Input.GetKeyDown(KeyCode.Space))
        {
            audioSource.pitch *= -1;
            print("space");
        }
    }

}
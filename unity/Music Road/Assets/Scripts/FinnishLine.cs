using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinnishLine : MonoBehaviour {
    // Start is called before the first frame update
    void Start() {
    }

    // Update is called once per frame
    void Update() {
    }

    private void OnTriggerEnter(Collider other)
    {
        FindObjectOfType<GameManager>().endGame(true);
    }

    private void OnCollisionEnter(Collision collision) {
        FindObjectOfType<GameManager>().endGame(true);
    }
    
}
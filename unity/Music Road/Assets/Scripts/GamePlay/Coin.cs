using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Coin : MonoBehaviour
{

    GameManager gm;
    private void Start() {
        gm = FindObjectOfType<GameManager>();
    }

    private void OnTriggerEnter(Collider other) {
        FindObjectOfType<GameManager>().addCoin();
        GameObject.Destroy(gameObject);
    }

    
}

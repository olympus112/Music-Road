using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour {
    [SerializeField]
    Vector3 relativeCameraPositionToPlayer = new Vector3(0, 20, 0);

    [SerializeField]
    Vector3 rotation = new Vector3(0, 45, 90);

    private Car player;
    private Vector3 playerPosition;


    // Start is called before the first frame update
    void Start() {
        // find player

        // rotate camera
        transform.rotation = Quaternion.Euler(rotation);
    }

    // Update is called once per frame
    void Update() {
        if (!player) {
            player = FindObjectOfType<Car>();
        } else {
            playerPosition = FindObjectOfType<Car>().transform.position;

            // verander camera positie
            transform.position = playerPosition + relativeCameraPositionToPlayer;
        }
        
    }
}
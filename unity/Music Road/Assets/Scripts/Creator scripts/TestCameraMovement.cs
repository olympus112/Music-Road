using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestCameraMovement : MonoBehaviour {
    [SerializeField]
    Vector3 relativeCameraPositionToPlayer = new Vector3(0, 20, 0);

    [SerializeField]
    Vector3 rotation = new Vector3(0, 45, 90);

    private TestCar player;
    private Vector3 playerPosition;


    // Start is called before the first frame update
    void Start() {
        // rotate camera
        transform.rotation = Quaternion.Euler(rotation);
    }

    // Update is called once per frame
    void Update() {
        if (!player) {
            player = FindObjectOfType<TestCar>();
        } else {
            playerPosition = player.transform.position;

            // verander camera positie
            transform.position = playerPosition + relativeCameraPositionToPlayer;
        }
        
    }

    public void setPlayer(TestCar car)
    {
        player = car;
    }
}
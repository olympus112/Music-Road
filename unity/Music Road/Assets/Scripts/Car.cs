using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour {
    [SerializeField]
    float speed = 5f;

    [SerializeField]
    Vector3 carDimensions = new Vector3(1.5f, 1.5f, 1.5f);

    private GameManager gameManager;
    private LevelProgressionMeter slider;

    private Vector3 movementdirection;
    private bool goingForward;

    //TODO : get the groundpos automatically here

    // Start is called before the first frame update
    void Start() {
        gameManager = FindObjectOfType<GameManager>();
        slider = FindObjectOfType<LevelProgressionMeter>();

        movementdirection = Vector3.forward;
        goingForward = true;

        transform.localScale = carDimensions;
    }

    // Update is called once per frame
    void Update() {
        // move
        float movement = speed * Time.deltaTime;
        transform.position += movementdirection * movement;
        slider.addDistance(movement);

        if (Input.GetMouseButtonDown(0))
            changeDirection();

        if (transform.position.y < -10) {
            print(transform.position.y);
            gameManager.endGame(false);
        }
    }

    void changeDirection() {
        // change direction
        movementdirection = goingForward ? Vector3.right : Vector3.forward;

        // change boolean
        goingForward = !goingForward;
    }

    public Vector3 getStartingPosition(Vector3 startPos) {
        return new Vector3(startPos.x, startPos.y + carDimensions.y / 2, startPos.z);
    }

    private void OnCollisionEnter(Collision collision) {
        print(collision.gameObject.transform.name);
        if (collision.gameObject.transform.name == "FinnishLine(Clone)")
            FindObjectOfType<GameManager>().endGame(true);
    }
}
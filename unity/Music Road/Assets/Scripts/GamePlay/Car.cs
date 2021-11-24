using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour {
    [SerializeField]
    float playerSpeed = 5f;

    [SerializeField]
    float jumpVelocity = 10f;

    [SerializeField]
    Vector3 carDimensions = new Vector3(1.5f, 1.5f, 1.5f);

    private GameManager gameManager;
    private LevelProgressionMeter slider;

    private Rigidbody ownBody;
    private Animator animator;

    private Vector3 startMousePosition;
    private Vector3 movementdirection;
    private bool goingForward;
    private bool jumping;
    private bool ducking;
    private bool gameEnded;
    private float speed;


    //TODO : get the groundpos automatically here

    // Start is called before the first frame update
    void Start() {


        gameManager = FindObjectOfType<GameManager>();
        slider = FindObjectOfType<LevelProgressionMeter>();

        ownBody = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();

        movementdirection = Vector3.forward;
        goingForward = true;
        jumping = false;
        gameEnded = false;

        transform.localScale = carDimensions;
    }

    // Update is called once per frame
    void Update() {
        // ------------------- Movement ------------------- 
        float movement = speed * Time.deltaTime;
        transform.position += movementdirection * movement;
        slider.addDistance(movement);

        // ------------------- Input -------------------
        
        if (Input.GetMouseButtonDown(0))
            startMousePosition = Input.mousePosition;

        // end of swipe or click
        if (Input.GetMouseButtonUp(0)) {

            if (speed == 0)
                gameManager.tapToStart();
            else if (!gameManager.paused)
            {
                float difference = Input.mousePosition.y - startMousePosition.y;
                if (difference >= 15)
                    jump();
                else if (difference <= -15)
                    duck();
                else
                    changeDirection();
            }
            
        }

        // ------------------- Death trigger -------------------
        if (transform.position.y < -10 && !gameEnded) {
            gameEnded = true;
            gameManager.endGame();
        }
    }

    void changeDirection() {
        // change direction
        movementdirection = goingForward ? Vector3.right : Vector3.forward;

        // change boolean
        goingForward = !goingForward;
    }

    void duck(){
        if (jumping)
            ownBody.velocity = new Vector3(0, -jumpVelocity * 2, 0);
        else if (!ducking) {
                animator.SetBool("ducking", true);
            ducking = true;
        }
    }

    void endDucking() { // voor de animatie correct te laten verlopen
        ducking = false;
        animator.SetBool("ducking", false);
    }

    void jump() {
        if (!jumping && transform.position.y >=0.7f)
            ownBody.velocity = new Vector3(0, jumpVelocity, 0);
        jumping = true;
    }

    public Vector3 getStartingPosition(Vector3 startPos) {
        return new Vector3(startPos.x, startPos.y + carDimensions.y / 2, startPos.z);
    }

    private void OnCollisionEnter(Collision collision) {
        jumping = false;
        if (collision.gameObject.transform.name == "FinnishLine(Clone)")
            FindObjectOfType<GameManager>().endGame();
    }

    public void revertPausedClick() {
        gameManager.recentleyPaused = false;
        changeDirection();
    }

    public void setSpeed() {
        speed = playerSpeed;
    }

}
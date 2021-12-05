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

    [SerializeField]
    float requiredDistanceForSwipe = 20f;

    private GameManager gameManager;
    private LevelProgressionMeter slider;

    private Rigidbody ownBody;
    private Animator animator;

    private Vector3 startMousePosition;
    private Vector3 movementdirection;
    private bool goingForward;
    private bool jumping;
    private bool ducking;
    private float speed;
    private bool died;
    private bool dying;
    private int dyingCounter;
    private bool swiping;
    private bool swiped;
    private bool tapToPlay;
    private bool gameEnded;


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
        dying = false;
        died = false;
        dyingCounter = 0;
        swiped = false;
        swiping = false;
        tapToPlay = true;
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
        
        if (Input.GetMouseButtonDown(0) && !gameEnded) {
            startMousePosition = Input.mousePosition;
            swiping = true;
            swiped = false;
        }

        if (swiping && !gameManager.paused && speed != 0 && !gameEnded) {
            Vector3 diff = Input.mousePosition - startMousePosition;
            if (diff.y >= requiredDistanceForSwipe) {
                jump();
                swiped = true;
                swiping = false;
            }
            else if (diff.y <= -requiredDistanceForSwipe) {
                duck();
                swiped = true;
                swiping = false;
            }
            else if (!tapToPlay) {
                if (diff.x >= requiredDistanceForSwipe && goingForward) {
                    changeDirection();
                    swiped = true;
                    swiping = false;
                }
                else if (diff.x <= -requiredDistanceForSwipe && !goingForward) {
                    changeDirection();
                    swiped = true;
                    swiping = false;
                }
            }
        }

        // end of swipe or click
        if (Input.GetMouseButtonUp(0) && !swiped && !gameEnded) {
            if (speed == 0)
                gameManager.tapToStart();
            else if (!gameManager.paused && tapToPlay) {
                changeDirection();
            }
            swiping = false;
            
        }

        // ------------------- Death trigger -------------------
        if (transform.position.y < -0.5 && !gameEnded)
            dying = true;

        if (dying)
            dyingCounter++;

        if ((dyingCounter >= 70 || (died && dyingCounter >= 7))&& !gameEnded) {
            gameManager.endGame();
            gameEnded = true;
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
        print("cardimension " + carDimensions.y);
        print(carDimensions.y/2 + startPos.y);
        return new Vector3(startPos.x, startPos.y + carDimensions.y / 2, startPos.z);
    }

    private void OnCollisionEnter(Collision collision) {
        jumping = false;
        if (collision.collider.tag == "Obstacle"){
            dying = true;
            died = true;
        }
           
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.collider.tag == "Obstacle") {
            dying = false;
            died = false;
            dyingCounter = 0;
        }
    }

    public void revertPausedClick() {
        changeDirection();
    }

    public void setSpeed() {
        speed = playerSpeed;
    }

    public void switchToSwipeToPlay() {
        tapToPlay = false;
    }

}
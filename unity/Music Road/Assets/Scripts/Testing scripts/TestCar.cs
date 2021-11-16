using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestCar : MonoBehaviour {
    [SerializeField]
    float speed = 5f;

    [SerializeField]
    float jumpVelocity = 10f;

    [SerializeField]
    Vector3 carDimensions = new Vector3(1.5f, 1.5f, 1.5f);

    private GameCreator gc;

    private Rigidbody ownBody;
    private Animator animator;

    private Vector3 startMousePosition;
    private Vector3 movementdirection;

    private bool goingForward;
    private bool jumping;
    private bool ducking;
    private float duckingStartTime;

    //TODO : get the groundpos automatically here

    // Start is called before the first frame update
    void Start() {

        ownBody = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();

        movementdirection = Vector3.forward;
        goingForward = true;
        jumping = false;

        transform.localScale = carDimensions;
    }

    // Update is called once per frame
    void Update() {
        // ------------------- Movement ------------------- 
        float movement = speed * Time.deltaTime;
        transform.position += movementdirection * movement;

        // ------------------- Input -------------------
        
        if (Input.GetMouseButtonDown(0))
            startMousePosition = Input.mousePosition;

        // end of swipe or click
        if (Input.GetMouseButtonUp(0))
        {
            float difference = Input.mousePosition.y - startMousePosition.y;
            if (difference >= 15){
                jump();
                
            }
            else if (difference <= -15) {
                duck();
                    
            }
            else {
                changeDirection();
                
            }
        }
    }

    void duck()
    {
        if (jumping)
            ownBody.velocity = new Vector3(0, -jumpVelocity * 2, 0);
        else if (!ducking){
            gc.createNewOverhang(transform.position);
            animator.SetBool("ducking", true);
            ducking = true;
        }
    }

    void endDucking()
    { // voor de animatie correct te laten verlopen
        ducking = false;
        animator.SetBool("ducking", false);
        gc.createNewOverhang(transform.position);
    }


    void changeDirection()
    {
        if (!jumping & !ducking) {
            // change direction
            movementdirection = goingForward ? Vector3.right : Vector3.forward;

            // change boolean
            goingForward = !goingForward;
            gc.createNewRoad(transform.position);
        }
    }
    void jump() {
        if (!jumping & !ducking) {
            gc.createNewRoad(transform.position);
            ownBody.velocity = new Vector3(0, jumpVelocity, 0);
            jumping = true;
        }
    }

    public Vector3 getStartingPosition(Vector3 startPos) {
        return new Vector3(startPos.x, startPos.y + carDimensions.y / 2, startPos.z);
    }

    private void OnCollisionEnter(Collision collision) {
        if (jumping) {
            print( "something");
            gc.updatePos(transform.position);
        }
            
        jumping = false;
        if (collision.gameObject.transform.name == "FinnishLine(Clone)")
            FindObjectOfType<GameManager>().endGame(true);
    }

    public void setGameCreator(GameCreator creator)
    {
        gc = creator;

        print(gc);
    }
}
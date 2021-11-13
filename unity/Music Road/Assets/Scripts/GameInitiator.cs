using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameInitiator : MonoBehaviour {
    [SerializeField]
    RoadSpawner roadSpawner;


    private int[] testRoads = new int[] { // jump length should be length + 12
            50, 10, 20, 30, 20, 40, 30, 17, 30, 50, 10, 20, 30, 40
        };
    private bool[] testRoadJumpIndicators = new bool[] {
            false, false, false, false, false, false, false, true, false, false, false, false, false, false
        };


    // Start is called before the first frame update
    // zal voor start uitgevoerd worden
    private void Start() {
        // spawn roads
        roadSpawner.instantiateRoads(testRoads, testRoadJumpIndicators);
    }

    // Update is called once per frame
    void Update() {
    }


    public float getTotalDistance() {
        float result = 0f;
        foreach (int length in testRoads) {
            result += length;
        }

        return result;
    }

}
﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameCreator : MonoBehaviour {
    [SerializeField]
    RoadSpawner roadSpawner;



    [SerializeField]
    TestCar car;
    [SerializeField]
    GameObject coin;
    [SerializeField]
    GameObject testRoad;
    [SerializeField]
    GameObject overHang;

    [SerializeField]
    float overhangLenght = 7f;
    [SerializeField]
    float roadWidth = 6f;
    [SerializeField]
    float roadHeightPos = -0.5f;
    [SerializeField]
    float distanceBetweenCoins = 3f;
    [SerializeField]
    int frequencyOfBigCoinClusters = 2;
    [SerializeField]
    int frequencyOfSmallCoinClusters = 3;
    [SerializeField]
    int lengthOfSmallCoinClusters = 5;


    private bool startedOverhead;
    private bool paused = false;
    private Vector3 lastTurnPos;
    private Vector3 startingOverheadPos;
    private int bigClusterCounter;
    private int smallClusterCounter;
    private int smallClusterLength;
    private bool inSmallCluster;

    // Start is called before the first frame update
    // zal voor start uitgevoerd worden
    private void Start() {
        TestCar player = Instantiate(car, car.getStartingPosition(new Vector3(0, 3, 0)), transform.rotation) as TestCar;
        FindObjectOfType<TestCameraMovement>().setPlayer(player);
        player.setGameCreator(this);
        lastTurnPos = player.transform.position;
        bigClusterCounter = 0;
        smallClusterCounter = frequencyOfSmallCoinClusters;
        smallClusterLength = 0;
        inSmallCluster = false;
    }

    public void createNewRoad(Vector3 currentTurnPos){
        Vector3 distance = currentTurnPos - lastTurnPos;
        Vector3 roadPos = lastTurnPos + distance / 2f;
        roadPos.y = roadHeightPos;
        lastTurnPos = currentTurnPos;

        
        Vector3 scale = new Vector3(distance.x+roadWidth, 1, distance.z+roadWidth);

        
        GameObject road = Instantiate(testRoad, roadPos, transform.rotation);
        road.transform.localScale = scale;

        float availableSpaceForCoins = (Mathf.Max(distance.x, distance.z));

        if (availableSpaceForCoins/distanceBetweenCoins > 3) {
            if (bigClusterCounter == 0) {
                placeMiddleCoins(road);
                bigClusterCounter = frequencyOfBigCoinClusters + 1;
            }
            bigClusterCounter--;
            inSmallCluster = false;
        }
        else if (distanceBetweenCoins < availableSpaceForCoins && availableSpaceForCoins < roadWidth * 2) {
            if (!inSmallCluster && smallClusterLength != 0) { //doe alsof je het einde van de cluster hebt bereikt 
                smallClusterLength = 0;
            }
            if (smallClusterCounter == 0) {
                smallClusterLength = lengthOfSmallCoinClusters;
                smallClusterCounter = frequencyOfSmallCoinClusters;
                inSmallCluster = true;
            }
            if (smallClusterLength != 0) {
                placeCornerCoins(lastTurnPos);
                smallClusterLength--;
            }
            else {
                inSmallCluster = false;
                smallClusterCounter--;
            }

        }
    }


    private void placeMiddleCoins(GameObject road) {
        float availableLenght = Mathf.Max(road.transform.localScale.x, road.transform.localScale.y)-roadWidth;
        int relativeStartingPlaceOfcoins = -1;
        if (availableLenght / distanceBetweenCoins > 5)
            relativeStartingPlaceOfcoins = -2;
        Vector3 direction = road.transform.localScale.x > road.transform.localScale.z ? Vector3.right : Vector3.forward;
        for (int i = relativeStartingPlaceOfcoins; i <= relativeStartingPlaceOfcoins * -1; i++) {
            Vector3 coinPos = direction * i * distanceBetweenCoins + new Vector3(0,1.25f,0);
            coinPos += road.transform.position;
            Instantiate(coin, coinPos, coin.transform.rotation);
            
        }
    }

    private void placeCornerCoins(Vector3 pos) {
        pos.y = 0.75f;
        Instantiate(coin, pos, coin.transform.rotation);
    }

    public void updatePos(Vector3 pos) {
        lastTurnPos = pos;
    }

    

    // TODO kan je dan nog altijd klikken om van richting te veranderen?
    public void pauseGame() {
        Time.timeScale = paused ? 1 : 0;

        paused = !paused;
    }

    public void createNewOverhang(Vector3 pos) {
        if (!startedOverhead) {
            createNewRoad(pos);
            startedOverhead = true;
            startingOverheadPos = pos;
        }
        else {
            Vector3 difference = pos - startingOverheadPos;
            Vector3 direction = difference.x > difference.z ? Vector3.right : Vector3.forward;

            float extraLength = Mathf.Max(difference.x, difference.z) - overhangLenght;
            extraLength /= 2; // want er komt een stuk bij aan elke kant van de overhang
            Vector3 extraRoadScale = direction * extraLength + new Vector3(roadWidth, 1, roadWidth);
            Vector3 centerRoad1 = startingOverheadPos + direction * extraLength / 2;
            centerRoad1.y = roadHeightPos;
            Vector3 centerRoad2 = pos - direction * extraLength / 2;
            centerRoad2.y = roadHeightPos;
            Vector3 centerOverHang = startingOverheadPos + difference / 2;
            centerOverHang.y = roadHeightPos;
 
            GameObject road1 = Instantiate(testRoad, centerRoad1, transform.rotation);
            road1.transform.localScale = extraRoadScale;

            GameObject road2 = Instantiate(testRoad, centerRoad2, transform.rotation);
            road2.transform.localScale = extraRoadScale;

            GameObject oh = Instantiate(overHang, centerOverHang, transform.rotation);
            oh.transform.localScale = new Vector3(Mathf.Max(direction.x * overhangLenght, roadWidth), 1, Mathf.Max(direction.z*overhangLenght,roadWidth)) ;

            startedOverhead = false;

            lastTurnPos = pos;
        }
    }
}
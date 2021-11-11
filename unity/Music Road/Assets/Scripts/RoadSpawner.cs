using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class RoadSpawner : MonoBehaviour {
    [SerializeField]
    int roadWidth = 6;

    [SerializeField]
    float roadHeight = 1f;

    [SerializeField]
    float roadSurfaceLevel = 0f;

    [SerializeField]
    GameObject roadPrefab;

    [SerializeField]
    FinnishLine finnish;

    [SerializeField]
    float finnishHeight = 2f;

    //TODO: zien of alle roads in een keer worden gespant of dat ze geleidelijk worden in gespawnt
    /// <summary>
    /// Zorgt dat een reeks van wegen gespanwt worden 
    /// </summary>
    /// <param name="lengths"> Een lijst van alle afstanden van de wegen</param>
    public void instantiateRoads(int[] lengths) {
        bool xAxis = false;

        //bereken y positie (hoogte) van het middelpunt van de weg
        float height = roadSurfaceLevel - (roadHeight / 2);

        Vector3 pos = new Vector3(0, height, 0); // midden positie van de 1ste weg 

        foreach (int length in lengths) {
            pos = updateRoadPos(length, pos, xAxis);
            instantiateRoad(length, xAxis, pos);
            pos = updateRoadPos(length, pos, xAxis);
            xAxis = !xAxis; // update directie
        }

        placeFinnishLine(pos);
    }


    private Vector3 updateRoadPos(int length, Vector3 pos, bool xAxis) {
        Vector3 direction = Vector3.forward; // = (0,0,1)
        if (xAxis) direction = Vector3.right; // = (1,0,0)

        return pos + direction * (length - roadWidth) / 2;
    }


    /// <summary> 
    /// Maakt een weg van de gegeven lengte die aan de gegeven positie ankert.
    /// </summary>
    /// <param name="length"> De lengte van de weg. </param>
    /// <param name="xAxis"> Is true als de weg langs de x-as ligt. </param>
    /// <param name="ankerPos"> De positie van het midden van de weg </param>
    void instantiateRoad(int length, bool xAxis, Vector3 roadPos) {
        // creëer de weg en maak hem de juiste grootte
        GameObject
            road = Instantiate(roadPrefab, roadPos,
                transform.rotation); // transform.rotation geeft het dezelfde rotatie als het gameObject waaraan dit scrîpt gelinkt is.

        if (xAxis)
            road.transform.localScale = new Vector3(length, roadHeight, roadWidth); // lengte ligt volgens de x-as 
        else
            road.transform.localScale = new Vector3(roadWidth, roadHeight, length); // lengte ligt volgens de z-as
    }

    void placeFinnishLine(Vector3 pos) {
        FinnishLine fLine = Instantiate(finnish, pos + Vector3.up * finnishHeight / 2, transform.rotation);
        fLine.transform.localScale = new Vector3(roadWidth, finnishHeight, roadWidth);
    }
}
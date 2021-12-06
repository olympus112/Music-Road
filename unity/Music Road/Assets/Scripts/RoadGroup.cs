using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoadGroup : MonoBehaviour
{
    int amountOfChildren;

    // Start is called before the first frame update
    void Start()
    {
        amountOfChildren  = transform.childCount;
        LevelProgressionMeter slider = FindObjectOfType<LevelProgressionMeter>();
        slider.setTotalDistance(getTotalDistance());
        print("total distance: ");
        print(getTotalDistance());
    }

    public float getTotalDistance() {
        //find last child
        Transform LastChild = transform.GetChild(amountOfChildren - 1);

        //calculate distance
        float length = LastChild.position.x + LastChild.position.z;
        length += Mathf.Max(LastChild.localScale.x, LastChild.localScale.z) / 2;

        return length;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

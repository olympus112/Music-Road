using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LavaPlane : MonoBehaviour
{
    [SerializeField]
    float maxHeight = 0;
    [SerializeField]
    float minHeight = -100;


    private LevelProgressionMeter slider;
    private float slidingDistance;
    private bool firstUpdate;
    // Start is called before the first frame update
    void Start()
    {
        slider = FindObjectOfType<LevelProgressionMeter>();
        slidingDistance = maxHeight - minHeight;
        Vector3 pos = transform.position;
        pos.y = minHeight;
        print(minHeight);
        transform.position = pos;
        firstUpdate = true;
    }

    // Update is called once per frame
    void Update()
    {
        float risePercentage = slider.getValue();
        if (risePercentage > 0 && transform.position.y <= maxHeight)
        {
            Vector3 pos = transform.position;
            pos.y = slidingDistance * risePercentage * 1.5f + minHeight;
            transform.position = pos;
        }
        else if (firstUpdate)
        {
            Vector3 pos = transform.position;
            pos.y = minHeight;
            transform.position = pos;
            firstUpdate = false;
        }
        else if (transform.position.y > 0)
            firstUpdate = true;
    }
}

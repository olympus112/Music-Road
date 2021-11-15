using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelProgressionMeter : MonoBehaviour {
    public float totalDistance;
    public float distanceCovered;
    private Slider slider;

    private void Start() {
        slider = GetComponent<Slider>();
        distanceCovered = 0f;
        if (FindObjectOfType<GameInitiator>())
            totalDistance = FindObjectOfType<GameInitiator>().getTotalDistance();

    }

    public void setTotalDistance(float distance) {
        totalDistance = distance;
    }

    public void addDistance(float distance) {
        distanceCovered += distance;
    }

    private void Update() {
        if (totalDistance > 0f)
            slider.value = distanceCovered / totalDistance;

    }
}
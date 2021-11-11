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
        totalDistance = FindObjectOfType<GameManager>().getTotalDistance();
    }

    public void addDistance(float distance) {
        distanceCovered += distance;
    }

    private void Update() {
        slider.value = distanceCovered / totalDistance;
    }
}
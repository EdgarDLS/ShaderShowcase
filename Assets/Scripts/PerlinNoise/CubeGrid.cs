using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeGrid : MonoBehaviour
{
    public Transform prefab;

    public int gridResolution = 10;

    Transform[] grid;

    void Awake()
    {
        for (int x = 0; x < gridResolution; x++)
        {
            for (int y = 0; y < gridResolution; y++)
            {
                CreateGridPoint(x, y);
            }
        }
    }

    private void CreateGridPoint(int _x, int _y)
    {
        Instantiate(prefab, new Vector3(_x, _y, 0), Quaternion.identity);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerlinMovement : MonoBehaviour
{
    public float xOrg;
    public float yOrg;

    public int pixWidth;
    public int pixHeight;

    private Texture2D noiseTex;
    public float scale = 1.0F;

    private void Start()
    {
        noiseTex = new Texture2D(pixWidth, pixHeight);
    }

    void Update()
    {
        float y = 0.0F;
        float x = 0.0F;

        float xCoord = xOrg + x / noiseTex.width * scale;
        float yCoord = yOrg + y / noiseTex.height * scale;

        transform.position = new Vector3(Mathf.PerlinNoise(xCoord, yCoord), this.transform.position.y, this.transform.position.z);
    }
}

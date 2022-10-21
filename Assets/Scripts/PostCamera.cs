using UnityEngine;

public class PostCamera : MonoBehaviour
{ // Copies aTexture to rTex and displays it in all cameras.

    public Texture aTexture;
    public RenderTexture rTex;
    public Material TransitionMaterial;
    void Start()
    {
        if (!aTexture || !rTex)
        {
            Debug.LogError("A texture or a render texture are missing, assign them.");
        }
    }

    void Update()
    {
        Graphics.Blit(aTexture, rTex, TransitionMaterial);
    }
    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (TransitionMaterial != null)
        {
            RenderTexture.active = dst;
            GL.Clear(false, true, Color.black);
            Graphics.Blit(src, dst, TransitionMaterial);
        }
    }
}
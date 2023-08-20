// Level design tool made by Sylve Renault
// https://github.com/kikar4u


using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.VersionControl;
using UnityEngine;
using System.IO;

public class LevelDesignEditor : EditorWindow
{
    public List<GameObject> availableObject = new List<GameObject>();
    public string folderPath = "Assets/";
    private List<GameObjectButtonData> buttonDataList = new List<GameObjectButtonData>();
    private Vector2 scrollPosition = Vector2.zero;

    [MenuItem("MyTools/LD-Tools")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(LevelDesignEditor));
    }

    private void OnGUI()
    {
        GUILayout.Label("LD-Tools", EditorStyles.helpBox);
        folderPath = GUILayout.TextArea(folderPath, EditorStyles.textArea);
        if (GUILayout.Button("Load Files"))
        {
            
            string[] objectFiles = Directory.GetFiles(folderPath, "*.prefab", SearchOption.AllDirectories);
            LoadPrefab(objectFiles);
        }
        if(availableObject.Count > 0)
        {
            GUILayout.Label("Available Objects");
            scrollPosition = GUILayout.BeginScrollView(scrollPosition);


            foreach (var buttonData in buttonDataList)
            {
                if (GUILayout.Button(buttonData.thumbnail, GUILayout.Width(64), GUILayout.Height(64)))
                {
                    Instantiate(buttonData.gameObject, Vector3.zero, Quaternion.identity);
                    // Handle button click
                    Debug.Log("Thumbnail button clicked! Selected GameObject: " + buttonData.gameObject.name);
                }
            }
            GUILayout.EndScrollView();
        }
    }
    private void LoadPrefab(string[] files)
    {
            // clear if window was already opened, prevent duplication
        if(availableObject.Count != 0)
            availableObject.Clear();
        if (buttonDataList.Count != 0)
            buttonDataList.Clear();
        // load prefab and add them to available objects
        foreach (string filePath in files)
        {
            if (File.Exists(filePath))
            {
                GameObject prefab = AssetDatabase.LoadAssetAtPath<GameObject>(filePath);
                
                if (prefab != null)
                {
                    Debug.Log("Loaded prefab " + prefab.name);
                    availableObject.Add(prefab);

                }
            }
        }
        // add button to datalist to handle each bool and data from it
        Debug.Log("Current prefab Available " + availableObject.Count);
        foreach (GameObject obj in availableObject)
        {
            Texture2D thumbnail = AssetPreview.GetAssetPreview(obj);
            GUILayout.Button(thumbnail, GUILayout.Width(64), GUILayout.Height(64));
            buttonDataList.Add(new GameObjectButtonData(obj, thumbnail));
        }
    }
    private class GameObjectButtonData
    {
        public GameObject gameObject;
        public Texture2D thumbnail;

        public GameObjectButtonData(GameObject gameObject, Texture2D thumbnail)
        {
            this.gameObject = gameObject;
            this.thumbnail = thumbnail;
        }
    }
}

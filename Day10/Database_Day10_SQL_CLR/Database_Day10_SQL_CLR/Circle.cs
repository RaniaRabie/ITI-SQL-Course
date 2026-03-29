using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.Native)]
public struct Circle: INullable
{
    public int x, y, radius;
    public override string ToString()
    {
        // Replace with your own code
        return $"my Circle = (x:{x.ToString()}, y:{y.ToString()}, radius:{radius.ToString()})";
    }
    
    public bool IsNull
    {
        get
        {
            // Put your code here
            return _null;
        }
    }
    
    public static Circle Null
    {
        get
        {
            Circle h = new Circle();
            h._null = true;
            return h;
        }
    }
    
    public static Circle Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;

        Circle circle = new Circle();

        string[] circleCoords = s.Value.Split(',');

        circle.x = int.Parse(circleCoords[0]);
        circle.y = int.Parse(circleCoords[1]);
        circle.radius = int.Parse(circleCoords[2]);

        return circle;
    }
    
    // This is a place-holder method
    public string Method1()
    {
        // Put your code here
        return string.Empty;
    }
    
    // This is a place-holder static method
    public static SqlString Method2()
    {
        // Put your code here
        return new SqlString("");
    }
    
    // This is a place-holder member field
    public int _var1;
 
    //  Private member
    private bool _null;
}
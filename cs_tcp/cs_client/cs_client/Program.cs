using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using P;
using Game;


namespace cs_client
{
    class MainClass
    {
        public static void Main(string[] args)
        {
            P.Son.fun();

            Socket client_socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            IPAddress ipAdress = IPAddress.Parse("127.0.0.1");
            IPEndPoint ipEndpoint = new IPEndPoint(ipAdress, 8888);
            client_socket.Connect(ipEndpoint);

            // 序列化
            StartGameResp message = new StartGameResp { ErrCode = 1 };
            byte[] bin = ProtobufUtils.Serialize(message);
            client_socket.Send(bin);

            // 反序列化
            byte[] recBuffer = new byte[2]; 
            client_socket.Receive(recBuffer);
            StartGameResp resp = ProtobufUtils.Deserialize<StartGameResp>(recBuffer);
            Console.WriteLine("resp: {0}", resp);

        }
    }
}

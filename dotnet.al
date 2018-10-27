dotnet
{
    assembly("M2Mqtt.Net")
    {
        Version = '4.3.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'null';

        type("uPLibrary.Networking.M2Mqtt.MqttClient"; "MqttClient") { }
        type("uPLibrary.Networking.M2Mqtt.Messages.MqttMsgPublishEventArgs"; "MqttMsgPublishEventArgs") { }
        type("uPLibrary.Networking.M2Mqtt.Messages.MqttMsgPublishedEventArgs"; "MqttMsgPublishedEventArgs") { }
        type("uPLibrary.Networking.M2Mqtt.Messages.MqttMsgSubscribedEventArgs"; "MqttMsgSubscribedEventArgs") { }
        type("uPLibrary.Networking.M2Mqtt.Messages.MqttMsgUnsubscribedEventArgs"; "MqttMsgUnsubscribedEventArgs") { }
    }

    assembly("mscorlib")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.EventArgs"; "EventArgs") { }

    }

}

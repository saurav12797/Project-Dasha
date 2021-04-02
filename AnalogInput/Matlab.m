channelID = 906882;


iftttURL = 'https://maker.ifttt.com/trigger/BodyPosture/with/key/mBCFXFiMfc-_x3zCD2cVz3gbzsgmo75AD6NWZj8XDGN';


readAPIKey = 'YO7BICPM40MHPSOV';

% Read the last two weeks of moisture data from ThingSpeak.
posturedata = thingSpeakRead(channelID,'NumDays',14,'Fields',1,'ReadKey',readAPIKey);

% Calculate the threshold from the recent data.
span=max(posturedata)-min(posturedata);
poorposture = 0.1*span+min(posturedata);

% Build the ThingSpeak URL.
thingSpeakURL = strcat('https://api.thingspeak.com/channels/',string(channelID),'/fields/1/last.txt');

% GET the data from ThingSpeak.
lastValue = str2double(webread(thingSpeakURL, 'api_key', readAPIKey));

if (lastValue>poorposture)
    lpgMessage = ' Bad Posture Detected! ';
    webwrite(iftttURL,'value1',lastValue,'value2',lpgMessage);
end

if (lastValue<poorposture)
    lpgMessage = ' Normal Posture ';
    webwrite(iftttURL,'value1',lastValue,'value2',lpgMessage);
end
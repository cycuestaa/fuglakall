# Fuglakall: Bird Call Recognition with Machine Learning
Our awesome app for mobile computing.

### ESTIMATED TIMELINE
## Prototype I – 2/26
- Can identify bird calls without other sounds present (train using Youtube audio and model provided by Acoustic Bird Detection on GitHub)
- Basic UI
- - Button to input sound (record)
- - Results label
- - User feedback (User verifies if labels are correct)

## Prototype II – 3/08
- Can differentiate between bird call and urban background noise to filter out (train using audio from Youtube and freefield1010, test using audio from Youtube)
- Full App UI 
- - Button to input sound (record)
- - Results label
- - Image data for the bird detected
- - Link with API for wikipedia facts
- - User feedback (User verifies if labels are correct)

## Product – 3/19 ((Stretch goals))
- Can identify when more than one bird call is present and isolates for sound evaluation 
- Polishing app 
- - App provides feedback to users on how to improve performance (uncover mic, call too faint, etc.)


## SERVER
test_mp3 = open('<file path>.mp3', 'rb')
send_files = {'audioFile':('test_name.mp3', test_mp3, 'audio/mpeg')}
r = requests.post(url, files=send_files)
print(r.status_code)
print(r.content)
  
where url = http://45.33.19.27:5000/predict
you can test if the server is working by going to http://45.33.19.27:5000/hello


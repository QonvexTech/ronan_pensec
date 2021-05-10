importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-messaging.js');


firebase.initializeApp({
     apiKey: "AIzaSyAvoeP7_E_GRPH7twQv6hiBtOeW78RuwVs",
     authDomain: "ronan-pensec.firebaseapp.com",
     projectId: "ronan-pensec",
     storageBucket: "ronan-pensec.appspot.com",
     messagingSenderId: "371760182349",
     appId: "1:371760182349:web:8ebef129cc1d3ef8091804",
     measurementId: "G-C1DGNQKJ9T"
});
if (firebase.messaging.isSupported()){
	const messaging = firebase.messaging();
}
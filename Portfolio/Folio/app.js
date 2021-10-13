/**
     * Easy selector helper function
     */
const select = (el, all = false) => {
    el = el.trim()
    if (all) {
        return [...document.querySelectorAll(el)]
    } else {
        return document.querySelector(el)
    }
}

/**
 * Easy event listener function
 */
const on = (type, el, listener, all = false) => {
    let selectEl = select(el, all)
    if (selectEl) {
        if (all) {
            selectEl.forEach(e => e.addEventListener(type, listener))
        } else {
            selectEl.addEventListener(type, listener)
        }
    }
}

// Nav hamburgerburger selections
const burger = document.querySelector("#burger-menu");
const ul = document.querySelector("nav ul");
const nav = document.querySelector("nav");

// Scroll to top selection
const scrollUp = document.querySelector("#scroll-up");
//const scrollUp = document.getElementById("scroll-up");

// Select nav links
const navLink = document.querySelectorAll(".nav-link");

// Hamburger menu function
burger.addEventListener("click", () => {
    ul.classList.toggle("show");
});

// Close hamburger menu when a link is clicked
navLink.forEach((link) =>
    link.addEventListener("click", () => {
        ul.classList.remove("show");
    })
);

// scroll to top functionality
scrollUp.addEventListener("click", () => {
    window.scrollTo({
        top: 0,
        left: 0,
        behavior: "smooth",
    });
});


/**
     * Preloader
     */
let preloader = select('#preloader');
if (preloader) {
    window.addEventListener('load', () => {
        preloader.remove()
    });
}

// Type Effect
const typed = select('.typed')
if (typed) {
    let typed_strings = typed.getAttribute('data-typed-items')
    typed_strings = typed_strings.split(',')
    new Typed('.typed', {
        strings: typed_strings,
        loop: true,
        typeSpeed: 100,
        backSpeed: 50,
        backDelay: 2000
    });

    window.addEventListener('load', () => {
        AOS.init({
            duration: 1000,
            easing: 'ease-in-out',
            once: true,
            mirror: false
        })
    });
}

function NCNW() {
    var url = "../Site/NCNW_Detail.html";
    window.location.href = url;    
}

function AME() {
    var url = "../Site/AME_Detail.html";
    window.location.href = url;
}

function DataReq() {
    var url = "../Site/DataReq_Detail.html";
    window.location.href = url;
}

function Resume() {
    var url = "https://drive.google.com/file/d/1jFxZbqOhIIJqdm-zqewQCMcvH6NbckZU/view?usp=sharing";
    window.location.href = url;
}
toastBtn.onclick = () => {
    sdk.toast({
        message: 'hello'
    }, (result) => {
        print('callbcak from native:' + result)
    })

}


let canGoBack = true
toggleBack.onclick = () => {
    canGoBack = !canGoBack
    print(canGoBack ? 'can go back' : 'can not goback');
    window.callJS.goBack = () => {
        return canGoBack ? 1 : 0
    }
}


function ajax(url) {
    return new Promise((resolve, reject) => {
        var xhr = new XMLHttpRequest()
        xhr.open('GET', url)
        xhr.send()

        xhr.onreadystatechange = (e => {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var json = JSON.parse(xhr.responseText)
                    resolve(json)
                } catch (e) {
                    reject(e)
                }

            }
        })
    })
}

requestBtn.onclick = () => {
    let iframe = document.createElement('iframe')
    iframe.style.display = 'none'
    iframe.src = 'xxx-app://toast'
    document.body.appendChild(iframe)
    // ajax发送的请求不会被拦截
    // ajax('xxx-app://toast').then(res=>{
    //     console.log(res)
    // })
}
import puppeteer from 'puppeteer';
(async () => {

    const browser = await puppeteer.launch();

    const page = await browser.newPage();

    //  __dirname is a global node variable that corresponds to the absolute
    // path of the folder containing the currently executing file
    await page.goto(`file://${__dirname}/document.html`, { waitUntil: 'networkidle0' }));
    const pdf = await page.pdf({
      path: 'puppeteer.pdf',
      margin: { top: '100px', right: '50px', bottom: '100px', left: '50px' },
      printBackground: true,
      format: 'A4',
    });

    await browser.close();
})();

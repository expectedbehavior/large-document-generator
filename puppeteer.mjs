import puppeteer from 'puppeteer';
import { fileURLToPath } from 'url';
import { dirname } from 'path';



(async () => {
  const originalLog = console.log;
  // Overwriting
  console.log = function () {
    var args = [].slice.call(arguments);
    originalLog.apply(console.log,[getCurrentDateString()].concat(args));
  };
  // Returns current timestamp
  function getCurrentDateString() {
    return (new Date()).toISOString() + ' ::';
  };

    const __filename = fileURLToPath(import.meta.url);
    const __dirname = dirname(__filename);

    console.log("Loading browser");

    const browser = await puppeteer.launch();

    const page = await browser.newPage();

    page.setJavaScriptEnabled(false);

    console.log("Loading document");


    //  __dirname is a global node variable that corresponds to the absolute
    // path of the folder containing the currently executing file
    await page.goto(`file://${__dirname}/document.html`, { waitUntil: 'networkidle0', timeout: 0 });

    console.log("Creating PDF");

    const pdf = await page.pdf({
      path: 'puppeteer.pdf',
      margin: { top: '100px', right: '50px', bottom: '100px', left: '50px' },
      printBackground: true,
      format: 'A4',
      timeout: 0,
    });

    await browser.close();
})();

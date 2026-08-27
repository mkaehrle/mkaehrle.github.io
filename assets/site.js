document.querySelectorAll("[data-site-updated]").forEach(el => {
  const updated = new Date(document.lastModified);
  if (Number.isNaN(updated.getTime())) return;
  el.dateTime = updated.toISOString().slice(0, 10);
  el.textContent = `Updated ${new Intl.DateTimeFormat("en-US", {
    month: "long",
    year: "numeric"
  }).format(updated)}`;
});

fetch("assets/dataset-status.json")
  .then(response => {
    if (!response.ok) throw new Error("Dataset status unavailable");
    return response.json();
  })
  .then(snapshot => {
    document.querySelectorAll("[data-dataset-field]").forEach(el => {
      const key = el.dataset.datasetField;
      if (snapshot[key] !== undefined) el.textContent = snapshot[key];
    });
  })
  .catch(() => {
    // The HTML contains readable fallback values for offline and file previews.
  });

const anatomyModes = {
  restriction: {
    title: "Restriction records",
    text: "Provider, taxon, geography, and treatment (including seasonal or conditional terms) define the restriction. A change to the treatment or geographic scope creates a new restriction."
  },
  observations: {
    title: "Evidence through time",
    text: "Each restriction observation records what a source reports at a point in time. Lists v1–v3 confirm R-001. List v4 reports a changed season, so R-001 ends and R-002 begins."
  }
};

document.querySelectorAll("[data-anatomy-mode]").forEach(button => {
  button.addEventListener("click", () => {
    const mode = button.dataset.anatomyMode;
    document.querySelectorAll("[data-anatomy-mode]").forEach(peer => {
      peer.setAttribute("aria-pressed", String(peer === button));
    });
    document.querySelector("[data-anatomy]")?.setAttribute("data-mode", mode);
    const title = document.querySelector("[data-anatomy-title]");
    const text = document.querySelector("[data-anatomy-text]");
    if (title) title.textContent = anatomyModes[mode].title;
    if (text) text.textContent = anatomyModes[mode].text;
  });
});

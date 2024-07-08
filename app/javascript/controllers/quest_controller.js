import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quest"
export default class extends Controller {
  async toggleStatus(event) {
    const questId = event.target.value;
    const completed = event.target.checked;
    const url = `/quests/${questId}/toggle_status`;

    const response = await fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ completed: completed })
    });

    if (response.ok) {
      const turboFrame = document.getElementById(`quest_${questId}`);
      Turbo.renderStreamMessage(await response.text());
    } else {
      console.log('Failed to update status');
    }
  }
}

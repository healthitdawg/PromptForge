const { ipcRenderer } = require('electron');

// Data Manager
class DataManager {
    constructor() {
        this.prompts = this.loadPrompts();
        this.categories = this.loadCategories();
        
        if (this.categories.length === 0) {
            this.addDefaultCategories();
        }
    }

    loadPrompts() {
        const data = localStorage.getItem('prompts');
        return data ? JSON.parse(data) : [];
    }

    loadCategories() {
        const data = localStorage.getItem('categories');
        return data ? JSON.parse(data) : [];
    }

    savePrompts() {
        localStorage.setItem('prompts', JSON.stringify(this.prompts));
    }

    saveCategories() {
        localStorage.setItem('categories', JSON.stringify(this.categories));
    }

    addDefaultCategories() {
        this.categories = [
            { id: this.generateId(), name: 'General', color: '#4285f4' },
            { id: this.generateId(), name: 'Code', color: '#34a853' },
            { id: this.generateId(), name: 'Writing', color: '#9334e6' },
            { id: this.generateId(), name: 'Analysis', color: '#fb8c00' }
        ];
        this.saveCategories();
    }

    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }

    addPrompt(prompt) {
        prompt.id = this.generateId();
        prompt.createdAt = new Date().toISOString();
        prompt.updatedAt = new Date().toISOString();
        this.prompts.unshift(prompt);
        this.savePrompts();
        return prompt;
    }

    updatePrompt(id, updates) {
        const index = this.prompts.findIndex(p => p.id === id);
        if (index !== -1) {
            this.prompts[index] = {
                ...this.prompts[index],
                ...updates,
                updatedAt: new Date().toISOString()
            };
            this.savePrompts();
            return this.prompts[index];
        }
        return null;
    }

    deletePrompt(id) {
        this.prompts = this.prompts.filter(p => p.id !== id);
        this.savePrompts();
    }

    addCategory(category) {
        category.id = this.generateId();
        this.categories.push(category);
        this.saveCategories();
        return category;
    }

    deleteCategory(id) {
        this.categories = this.categories.filter(c => c.id !== id);
        this.prompts.forEach(p => {
            if (p.categoryId === id) {
                p.categoryId = null;
            }
        });
        this.saveCategories();
        this.savePrompts();
    }

    getCategoryById(id) {
        return this.categories.find(c => c.id === id);
    }

    getPromptsByCategory(categoryId) {
        if (!categoryId) return this.prompts;
        return this.prompts.filter(p => p.categoryId === categoryId);
    }

    searchPrompts(query) {
        if (!query) return this.prompts;
        const lowerQuery = query.toLowerCase();
        return this.prompts.filter(p => 
            p.title.toLowerCase().includes(lowerQuery) ||
            p.content.toLowerCase().includes(lowerQuery) ||
            (p.tags && p.tags.some(tag => tag.toLowerCase().includes(lowerQuery)))
        );
    }
}

// UI Manager
class UIManager {
    constructor(dataManager) {
        this.dataManager = dataManager;
        this.selectedCategory = null;
        this.selectedPrompt = null;
        this.editingPrompt = null;
        this.searchQuery = '';
        
        this.initElements();
        this.attachEvents();
        this.render();
    }

    initElements() {
        this.categoryList = document.getElementById('category-list');
        this.promptsList = document.getElementById('prompts-list');
        this.detailSection = document.getElementById('detail-section');
        this.searchInput = document.getElementById('search-input');
        
        // Modal elements
        this.promptModal = document.getElementById('prompt-modal');
        this.categoryModal = document.getElementById('category-modal');
    }

    attachEvents() {
        // Search
        this.searchInput.addEventListener('input', (e) => {
            this.searchQuery = e.target.value;
            this.renderPromptsList();
        });

        // New prompt button
        document.getElementById('new-prompt-btn').addEventListener('click', () => {
            this.openPromptModal();
        });

        // Add category button
        document.getElementById('add-category-btn').addEventListener('click', () => {
            this.openCategoryModal();
        });

        // Prompt modal
        document.getElementById('modal-close').addEventListener('click', () => {
            this.closePromptModal();
        });
        document.getElementById('modal-cancel').addEventListener('click', () => {
            this.closePromptModal();
        });
        document.getElementById('modal-save').addEventListener('click', () => {
            this.savePrompt();
        });

        // Category modal
        document.getElementById('category-modal-close').addEventListener('click', () => {
            this.closeCategoryModal();
        });
        document.getElementById('category-modal-cancel').addEventListener('click', () => {
            this.closeCategoryModal();
        });
        document.getElementById('category-modal-save').addEventListener('click', () => {
            this.saveCategory();
        });

        // Detail actions
        document.getElementById('copy-btn').addEventListener('click', () => {
            this.copyToClipboard();
        });
        document.getElementById('edit-btn').addEventListener('click', () => {
            if (this.selectedPrompt) {
                this.openPromptModal(this.selectedPrompt);
            }
        });
        document.getElementById('delete-btn').addEventListener('click', () => {
            if (this.selectedPrompt) {
                this.deletePrompt(this.selectedPrompt.id);
            }
        });

        // Color picker
        document.querySelectorAll('.color-option').forEach(option => {
            option.addEventListener('click', (e) => {
                document.querySelectorAll('.color-option').forEach(o => o.classList.remove('active'));
                e.target.classList.add('active');
            });
        });

        // IPC listeners
        ipcRenderer.on('new-prompt', () => {
            this.openPromptModal();
        });
    }

    render() {
        this.renderCategories();
        this.renderPromptsList();
        this.renderDetail();
    }

    renderCategories() {
        const allItem = `
            <li class="category-item ${!this.selectedCategory ? 'active' : ''}" data-category="all">
                <span class="category-icon">📁</span>
                <span class="category-name">All Prompts</span>
                <span class="category-count">${this.dataManager.prompts.length}</span>
            </li>
        `;

        const categoryItems = this.dataManager.categories.map(cat => {
            const count = this.dataManager.getPromptsByCategory(cat.id).length;
            return `
                <li class="category-item ${this.selectedCategory === cat.id ? 'active' : ''}" 
                    data-category="${cat.id}">
                    <span class="category-icon" style="color: ${cat.color}">●</span>
                    <span class="category-name">${cat.name}</span>
                    <span class="category-count">${count}</span>
                </li>
            `;
        }).join('');

        this.categoryList.innerHTML = allItem + categoryItems;

        // Attach click events
        this.categoryList.querySelectorAll('.category-item').forEach(item => {
            item.addEventListener('click', (e) => {
                const categoryId = e.currentTarget.getAttribute('data-category');
                this.selectedCategory = categoryId === 'all' ? null : categoryId;
                this.selectedPrompt = null;
                this.render();
            });
        });
    }

    renderPromptsList() {
        let prompts = this.searchQuery 
            ? this.dataManager.searchPrompts(this.searchQuery)
            : this.dataManager.getPromptsByCategory(this.selectedCategory);

        if (prompts.length === 0) {
            this.promptsList.innerHTML = `
                <div class="empty-state">
                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                    </svg>
                    <h3>${this.searchQuery ? 'No prompts found' : 'No prompts yet'}</h3>
                    <p>${this.searchQuery ? 'Try a different search' : 'Click "New Prompt" to create your first prompt'}</p>
                </div>
            `;
            return;
        }

        const promptItems = prompts.map(prompt => {
            const category = prompt.categoryId ? this.dataManager.getCategoryById(prompt.categoryId) : null;
            const categoryBadge = category ? `<span class="category-badge" style="background: ${category.color}22; color: ${category.color}">${category.name}</span>` : '';
            const tags = prompt.tags ? prompt.tags.slice(0, 3).map(tag => `<span class="tag-badge">${tag}</span>`).join('') : '';
            
            return `
                <div class="prompt-item ${this.selectedPrompt?.id === prompt.id ? 'active' : ''}" data-id="${prompt.id}">
                    <div class="prompt-item-title">${prompt.title}</div>
                    <div class="prompt-item-content">${prompt.content}</div>
                    <div class="prompt-item-meta">
                        ${categoryBadge}
                        ${tags}
                    </div>
                </div>
            `;
        }).join('');

        this.promptsList.innerHTML = promptItems;

        // Attach click events
        this.promptsList.querySelectorAll('.prompt-item').forEach(item => {
            item.addEventListener('click', (e) => {
                const id = e.currentTarget.getAttribute('data-id');
                this.selectedPrompt = this.dataManager.prompts.find(p => p.id === id);
                this.render();
            });
        });
    }

    renderDetail() {
        const emptyDiv = this.detailSection.querySelector('.detail-empty');
        const contentDiv = this.detailSection.querySelector('.detail-content');

        if (!this.selectedPrompt) {
            emptyDiv.style.display = 'flex';
            contentDiv.style.display = 'none';
            return;
        }

        emptyDiv.style.display = 'none';
        contentDiv.style.display = 'flex';

        document.getElementById('detail-title').textContent = this.selectedPrompt.title;
        document.getElementById('detail-content').textContent = this.selectedPrompt.content;
        document.getElementById('char-count').textContent = `${this.selectedPrompt.content.length} characters`;

        const category = this.selectedPrompt.categoryId ? this.dataManager.getCategoryById(this.selectedPrompt.categoryId) : null;
        const categoryBadge = document.getElementById('detail-category');
        if (category) {
            categoryBadge.style.display = 'inline-block';
            categoryBadge.textContent = category.name;
            categoryBadge.style.background = `${category.color}22`;
            categoryBadge.style.color = category.color;
        } else {
            categoryBadge.style.display = 'none';
        }

        const tagsContainer = document.getElementById('detail-tags');
        if (this.selectedPrompt.tags && this.selectedPrompt.tags.length > 0) {
            tagsContainer.innerHTML = this.selectedPrompt.tags.map(tag => 
                `<span class="tag-badge">${tag}</span>`
            ).join('');
        } else {
            tagsContainer.innerHTML = '';
        }

        const updatedDate = new Date(this.selectedPrompt.updatedAt);
        document.getElementById('detail-updated').textContent = `Updated: ${updatedDate.toLocaleDateString()} ${updatedDate.toLocaleTimeString()}`;
    }

    openPromptModal(prompt = null) {
        this.editingPrompt = prompt;
        const modalTitle = document.getElementById('modal-title');
        modalTitle.textContent = prompt ? 'Edit Prompt' : 'New Prompt';

        // Populate category dropdown
        const categorySelect = document.getElementById('prompt-category');
        categorySelect.innerHTML = '<option value="">None</option>' + 
            this.dataManager.categories.map(cat => 
                `<option value="${cat.id}" ${prompt && prompt.categoryId === cat.id ? 'selected' : ''}>${cat.name}</option>`
            ).join('');

        if (prompt) {
            document.getElementById('prompt-title').value = prompt.title;
            document.getElementById('prompt-content').value = prompt.content;
            document.getElementById('prompt-tags').value = prompt.tags ? prompt.tags.join(', ') : '';
        } else {
            document.getElementById('prompt-title').value = '';
            document.getElementById('prompt-content').value = '';
            document.getElementById('prompt-tags').value = '';
            categorySelect.value = '';
        }

        this.promptModal.classList.add('active');
    }

    closePromptModal() {
        this.promptModal.classList.remove('active');
        this.editingPrompt = null;
    }

    savePrompt() {
        const title = document.getElementById('prompt-title').value.trim();
        const content = document.getElementById('prompt-content').value.trim();
        const categoryId = document.getElementById('prompt-category').value || null;
        const tagsText = document.getElementById('prompt-tags').value.trim();
        const tags = tagsText ? tagsText.split(',').map(t => t.trim()).filter(t => t) : [];

        if (!title || !content) {
            alert('Please enter both title and content');
            return;
        }

        if (this.editingPrompt) {
            this.dataManager.updatePrompt(this.editingPrompt.id, {
                title,
                content,
                categoryId,
                tags
            });
            this.selectedPrompt = this.dataManager.prompts.find(p => p.id === this.editingPrompt.id);
        } else {
            const newPrompt = this.dataManager.addPrompt({
                title,
                content,
                categoryId,
                tags
            });
            this.selectedPrompt = newPrompt;
        }

        this.closePromptModal();
        this.render();
    }

    deletePrompt(id) {
        if (confirm('Are you sure you want to delete this prompt?')) {
            this.dataManager.deletePrompt(id);
            this.selectedPrompt = null;
            this.render();
        }
    }

    openCategoryModal() {
        document.getElementById('category-name').value = '';
        document.querySelectorAll('.color-option').forEach((o, i) => {
            o.classList.toggle('active', i === 0);
        });
        this.categoryModal.classList.add('active');
    }

    closeCategoryModal() {
        this.categoryModal.classList.remove('active');
    }

    saveCategory() {
        const name = document.getElementById('category-name').value.trim();
        const activeColor = document.querySelector('.color-option.active');
        const color = activeColor ? activeColor.getAttribute('data-color') : '#4285f4';

        if (!name) {
            alert('Please enter a category name');
            return;
        }

        this.dataManager.addCategory({ name, color });
        this.closeCategoryModal();
        this.render();
    }

    async copyToClipboard() {
        if (this.selectedPrompt) {
            const success = await ipcRenderer.invoke('copy-to-clipboard', this.selectedPrompt.content);
            if (success) {
                const btn = document.getElementById('copy-btn');
                const originalText = btn.innerHTML;
                btn.innerHTML = `
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    Copied!
                `;
                setTimeout(() => {
                    btn.innerHTML = originalText;
                }, 2000);
            }
        }
    }
}

// Initialize app
const dataManager = new DataManager();
const uiManager = new UIManager(dataManager);
